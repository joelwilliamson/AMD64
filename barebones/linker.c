#include <unistd.h>
#include <fcntl.h>
#include <error.h>
#include <errno.h>
#include <string.h>

int main(int argc, char** argv) {
	/* argv[0] = "linker"
	 * argv[1] = source program
	 * argv[2] = target file
	 */
	int source = open(argv[1],O_RDONLY);
	if (source == -1) {
		error(1,errno,"The source file %s failed to open.",argv[1]);
	}
	int target = open(argv[2],O_WRONLY | O_CREAT);
	if (target == -1) {
		error (1,errno,"The target file %s failed to open.",argv[2]);
	}
	
	static char buf[512]; 	// The desired contents of the MBR
				// Statically allocated buffers are
				// zero-initialized

	#define MBR_BOOTSTRAP_SIZE 446
	int bytes_read = read(source,buf,MBR_BOOTSTRAP_SIZE);
	if (bytes_read == -1) {
		error(1,errno,"Reading from source file failed.");
	}

	#define MBR_PARTITION_TABLE_SIZE 64
	// Zero out the partition table
	// Not nescessary since the buffer is statically allocated
	memset(buf+MBR_BOOTSTRAP_SIZE,0,MBR_PARTITION_TABLE_SIZE);

	// Magic bytes
	buf[510] = 0x55;
	buf[511] = 0xaa;

	int bytes_written = write(target,buf,512);
	if (bytes_written == -1) {
		error(1,errno,"Writing to target failed.");
	}

	close(source);
	close(target);

	return 0;
}

