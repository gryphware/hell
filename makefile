AS = as         #compiler
LD = ld			#linker

AS_FLAGS = --32 			#all code is 32bits only
LD_FLAGS = -m elf_i386		#linker as a 32bits exec files

SRC_DIR = src/i386_syntax
OBJ_DIR = obj

ifdef FILE                  #get input from user from exect file
	BASE_NAME = $(notdir $(basename $(FILE)))
	SRC       = $(SRC_DIR)/$(BASE_NAME).s
	OBJ		  = $(OBJ_DIR)/$(BASE_NAME).o
	TARGET    = $(BASE_NAME)
else						#in case no input from user
	SRC 	  = $(wildcard $(SRC_DIR)/*.s)
	OBJ		  = $(patsubst $(SRC_DIR)/%.s, $(OBJ_DIR)/%.o, $(SRC))
	TARGET    = program     #defult name for makefile
endif

#base build for execute files (some what?)
ifdef FILE
all: $(TARGET)
else
all: $(OBJ_DIR) $(OBJ)
endif

$(TARGET): $(OBJ) $(DEPS) | $(OBJ_DIR)
	$(LD) $(LD_FLAGS) $(OBJ) $(DEPS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s | $(OBJ_DIR)
	$(AS) $(AS_FLAGS) $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR)/*.o

.PHONY: all clean
