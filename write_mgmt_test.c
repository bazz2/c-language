#include<stdio.h>
#include<string.h>

int main()
{
	const char *mgmt = "/sys/kernel/osnsanserver/handlers/vdisk_blockio/mgmt";
	const char *cmd_ok = "del_device chenjt filename=/dev/VG01/base";
	const char *cmd_err = "del_device chenjt/test filename=/dev/VG01/base";
	FILE *fp = fopen(mgmt, "w");
	int count = fwrite(cmd_ok, 1, strlen(cmd_ok)+1, fp);
	fclose(fp);
	printf("ok: %d, strlen: %d\n", count, strlen(cmd_ok));
	fp = fopen(mgmt, "w");
	count = fwrite(cmd_err, 1, strlen(cmd_err)+1, fp);
	fclose(fp);
	printf("err: %d, strlen: %d\n", count, strlen(cmd_err));
	return 0;
}
