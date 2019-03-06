EXECUTABLE := vj

CC_FILES   := vj_utils.c vj_cascade_classifier.c vj_main.c

OBJDIR=objs
CC=g++ -m64
CFLAGS=-O3 -Wall -std=c++11

OBJS= $(OBJDIR)/vj_utils.o $(OBJDIR)/vj_cascade_classifier.o $(OBJDIR)/vj_main.o

.PHONY: dirs clean

default: $(EXECUTABLE)

dirs:
	mkdir -p $(OBJDIR)/

clean:
	rm -rf $(OBJDIR) $(EXECUTABLE)

$(EXECUTABLE): dirs $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

$(OBJDIR)/%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@

