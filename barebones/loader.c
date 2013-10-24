#include <fcntl.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdint.h>
#include <error.h>
#include <errno.h>

char message[] = "This message should be found near the beginning of sector 2.\n\r";
uint16_t sector_magic = 0xdada;
uint16_t code_magic = 0xadad;

int main(int argc, char* argv[]) {
	/* As usual argv[0] = program name
	 * 	argv[1] = input file
	 * 	argv[2] = output file
	 */
	size_t message_size = sizeof(message) + sizeof(message)%2;
	if (argc != 3) {
		error(1,0,"%s: input_file output_file",argv[0]);
	}
	int source = open(argv[1],O_RDONLY);
	if (!source) {
		error(1,errno,"%s failed to open for reading.",argv[1]);
	}
	int target = open(argv[2],O_WRONLY | O_CREAT,S_IRUSR | S_IWUSR);
	if (!target) {
		error(1,errno,"%s failed to open for writing.",argv[2]);
	}

	char program_text[512]; // load_code can't currently deal with more than 1 sector anyways
	size_t available_bytes = 512 - sizeof(sector_magic) - sizeof(code_magic) - message_size; // %2 is to get it word aligned
	size_t bytes_read;
	bytes_read = read(source,program_text,512);
	if (bytes_read == -1) {
		error(1,errno,"Failed to read.");
	} else if (bytes_read == 0) {
		error(1,errno,"File was empty.");
	} else if (bytes_read > available_bytes) {
		error(1,0,"Read more bytes than are available in output.");
	}

	char buf[512];
	memset(buf,0xff,512); // Fill the buffer with ones
	memcpy(buf,&sector_magic,2); // Start with some magic
	memcpy(buf+2,&message,sizeof(message));
	memcpy(buf+2+message_size,&code_magic,2);
	memcpy(buf+4+message_size,program_text,bytes_read);

	size_t bytes_written = write(target,buf,sizeof(buf));
	if (bytes_written == -1) {
		error(1,errno,"Write failed.");
	}

	close(source);
	close(target);
}
