#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <scsi/scsi_ioctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <scsi/sg.h>
#include <sys/ioctl.h>

#define SENSE_LEN       255
#define BLOCK_LEN       32
#define PRODUCT_LEN     32

unsigned char sense_buffer[SENSE_LEN];
unsigned char data_buffer[BLOCK_LEN*256];

struct sdev_info_t {
	char *vendor;
	char *product;
	char *revision;

	char *sense; /* store the error information */

	/* qualifier: 0->correct, 1->no connected lu,
	 * 3->no capable of supportting lu, else->reserved or vendor specific */
	int qualifier; 
	int sdev_type; /* 0->direct-access, 5->CDROM, etc */
};


static struct  sg_io_hdr * init_io_hdr()
{
	struct sg_io_hdr * p_scsi_hdr;
	if (!(p_scsi_hdr = (struct sg_io_hdr *)malloc(sizeof(struct sg_io_hdr)))) {
		return NULL;
	}
	memset(p_scsi_hdr, 0, sizeof(struct sg_io_hdr));
	if (p_scsi_hdr) {
		/* 'S' is the only choice we have */
		p_scsi_hdr->interface_id = 'S';
		/* this would put the LUN to 2nd byte of cdb */
		p_scsi_hdr->flags = SG_FLAG_LUN_INHIBIT;
	}

	return p_scsi_hdr;
}

static void destroy_io_hdr(struct sg_io_hdr * p_hdr)
{
	if (p_hdr) {
		free(p_hdr);
	}
}

static void set_xfer_data(struct sg_io_hdr *p_hdr, void *data, unsigned int length)
{
	if (p_hdr) {
		p_hdr->dxferp = data;
		p_hdr->dxfer_len = length;
	}
}

static void set_sense_data(struct sg_io_hdr *p_hdr, unsigned char *data,
		unsigned int length)
{
	if (p_hdr) {
		p_hdr->sbp = data;
		p_hdr->mx_sb_len = length;
	}
}

static void set_inquiry_cmd(int fd, int page_code, int evpd, struct sg_io_hdr *p_hdr)
{
	unsigned char cdb[6];

	/* set the cdb format */
	cdb[0] = 0x12; /*This is for Inquery*/
	cdb[1] = evpd & 1;
	cdb[2] = page_code & 0xff;
	cdb[3] = 0;
	cdb[4] = 0xff;
	cdb[5] = 0; /*For control filed, just use 0*/

	p_hdr->dxfer_direction = SG_DXFER_FROM_DEV;
	p_hdr->cmdp = cdb;
	p_hdr->cmd_len = 6;
}

static void show_hdr_outputs(struct sg_io_hdr * hdr)
{
	printf("status:%d\n", hdr->status);
	printf("masked_status:%d\n", hdr->masked_status);
	printf("msg_status:%d\n", hdr->msg_status);
	printf("sb_len_wr:%d\n", hdr->sb_len_wr);
	printf("host_status:%d\n", hdr->host_status);
	printf("driver_status:%d\n", hdr->driver_status);
	printf("resid:%d\n", hdr->resid);
	printf("duration:%d\n", hdr->duration);
	printf("info:%d\n", hdr->info);
}

static char *get_sense_buffer(struct sg_io_hdr * hdr)
{
	int i;
	char *dst;
	unsigned char *buffer = hdr->sbp;

	if (!buffer)
		return NULL;

	if (!(dst = calloc(1, SENSE_LEN))) {
		return NULL;
	}

	for (i = 0; i < hdr->mx_sb_len; i++) {
		dst[i] = buffer[i];
	}
	dst[i] = 0;

	return dst;
}

static char *get_vendor(struct sg_io_hdr * hdr)
{
	int i;
	char *dst;
	unsigned char * buffer = hdr->dxferp;

	if (!(dst = calloc(1, PRODUCT_LEN))) {
		return NULL;
	}

	for (i = 8; i < 16; i++) {
		dst[i-8] = buffer[i];
	}
	dst[i-8] = 0;

	return dst;
}

static char *get_product(struct sg_io_hdr * hdr)
{
	int i;
	char *dst;
	unsigned char *buffer = hdr->dxferp;

	if (!(dst = calloc(1, PRODUCT_LEN))) {
		return NULL;
	}

	for (i = 16; i < 32; i++) {
		dst[i-16] = buffer[i];
	}
	dst[i-16] = 0;

	return dst;
}

static char *get_product_rev(struct sg_io_hdr * hdr)
{
	int i;
	char *dst;
	unsigned char *buffer = hdr->dxferp;

	if (!(dst = calloc(1, PRODUCT_LEN))) {
		return NULL;
	}

	for (i = 32; i < 36; i++) {
		dst[i-32] = buffer[i];
	}
	dst[i-32] = 0;

	return dst;
}

void free_sdev_info(struct sdev_info_t *sinfo)
{
	if (!sinfo)
		return;
	free(sinfo->sense);
	free(sinfo->vendor);
	free(sinfo->product);
	free(sinfo->revision);
}

struct sdev_info_t *scsi_inquiry(const char *path)
{
	int fd, ret;
	struct sg_io_hdr *p_hdr;
	struct sdev_info_t *si;

	if (-1 == (fd = open(path, O_RDWR))) {
		return NULL;
	}

	if (!(p_hdr = init_io_hdr())) {
		return NULL;
	}
	set_xfer_data(p_hdr, data_buffer, BLOCK_LEN*256);
	set_sense_data(p_hdr, sense_buffer, SENSE_LEN);
	set_inquiry_cmd(fd, 0, 0, p_hdr);
	if (-1 == ioctl(fd, SG_IO, p_hdr)) {
		close(fd);
	}

printf("device %s status: %d\n", path, p_hdr->status);
	if (p_hdr->status != 0) {
		close(fd);
		return NULL;
	} else{
		si = calloc(1, sizeof (struct sdev_info_t));
		si->vendor = get_vendor(p_hdr);
		si->product = get_product(p_hdr);
		si->revision = get_product_rev(p_hdr);
		si->qualifier = (((char *)p_hdr->dxferp)[0] & 0xe0) >> 5;
		si->sdev_type = ((char *)p_hdr->dxferp)[0] & 0x1f;
	}
	close(fd);
	destroy_io_hdr(p_hdr);

	return si;
}

void main(int argc, char **argv)
{
	scsi_inquiry(argv[1]);
}
