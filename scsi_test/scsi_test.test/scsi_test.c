#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <scsi/scsi_ioctl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <scsi/sg.h>
#include <sys/ioctl.h>

#define SENSE_LEN 	255
#define BLOCK_LEN 	32
#define SCSI_TIMEOUT	20000

unsigned char sense_buffer[SENSE_LEN];
unsigned char data_buffer[BLOCK_LEN*256];

struct  sg_io_hdr * init_io_hdr() {

	struct sg_io_hdr * p_scsi_hdr = (struct sg_io_hdr *)malloc(sizeof(struct sg_io_hdr));
	memset(p_scsi_hdr, 0, sizeof(struct sg_io_hdr));
	if (p_scsi_hdr) {
		p_scsi_hdr->interface_id = 'S'; /* this is the only choice we have! */
		p_scsi_hdr->flags = SG_FLAG_LUN_INHIBIT; /* this would put the LUN to 2nd byte of cdb*/
	}

	return p_scsi_hdr;
}

void destroy_io_hdr(struct sg_io_hdr * p_hdr) {
	if (p_hdr) {
		free(p_hdr);
	}
}

void set_xfer_data(struct sg_io_hdr * p_hdr, void * data, unsigned int length) {
	if (p_hdr) {
		p_hdr->dxferp = data;
		p_hdr->dxfer_len = length;
	}
}

void set_sense_data(struct sg_io_hdr * p_hdr, unsigned char * data,
		unsigned int length) {
	if (p_hdr) {
		p_hdr->sbp = data;
		p_hdr->mx_sb_len = length;
	}
}
int execute_Inquiry(int fd, int page_code, int evpd, struct sg_io_hdr * p_hdr) {
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
	ioctl(fd, SG_IO, p_hdr);
}
void show_sense_buffer(struct sg_io_hdr * hdr) {
	unsigned char * buffer = hdr->sbp;
	int i;
	for (i=0; i<hdr->mx_sb_len; ++i) {
		putchar(buffer[i]);
	}
}

void show_vendor(struct sg_io_hdr * hdr) {
	unsigned char * buffer = hdr->dxferp;
	int i;
	printf("vendor id:");
	for (i=8; i<16; ++i) {
		putchar(buffer[i]);
	}
	putchar('\n');
}

void show_product(struct sg_io_hdr * hdr) {
	unsigned char * buffer = hdr->dxferp;
	int i;
	printf("product id:");
	for (i=16; i<32; ++i) {
		putchar(buffer[i]);
	}
	putchar('\n');
}

void show_product_rev(struct sg_io_hdr * hdr) {
	unsigned char * buffer = hdr->dxferp;
	int i;
	printf("product ver:");
	for (i=32; i<36; ++i) {
		putchar(buffer[i]);
	}
	putchar('\n');
}

void test_execute_Inquiry(char * path) {

	struct sg_io_hdr * p_hdr = init_io_hdr();

	set_xfer_data(p_hdr, data_buffer, BLOCK_LEN*256);
	set_sense_data(p_hdr, sense_buffer, SENSE_LEN);

	int status = 0;

	int fd = open(path, O_RDWR);
	if (fd>0) {
		execute_Inquiry(fd, 0, 0, p_hdr);

		printf("the return status is %d\n", p_hdr->status);
		if (status!=0) {
			show_sense_buffer(p_hdr);
		} else{
			show_vendor(p_hdr);
			show_product(p_hdr);
			show_product_rev(p_hdr);
		}
	} else {
		printf("failed to open sg file %s\n", path);
	}
	close(fd);
	destroy_io_hdr(p_hdr);
}

int main(int argc, char * argv[]) {
	test_execute_Inquiry(argv[1]);
	return EXIT_SUCCESS;
}
