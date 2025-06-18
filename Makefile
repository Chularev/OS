ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/sasha_floppy.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/sasha_floppy.img
	truncate -s 1440k $(BUILD_DIR)/sasha_floppy.img
	
$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.asm
	mkdir -p $(BUILD_DIR)
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin
