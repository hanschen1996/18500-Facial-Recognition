EXECUTABLE := vj

TEST := vj_tests

CC_FILES   := vj_utils.c vj_cascade_classifier.c vj_main.c

OBJDIR=objs
CC=g++ -m64
CFLAGS=-O3 -Wall -std=c++11

EXEC_OBJS= $(OBJDIR)/vj_io.o $(OBJDIR)/vj_utils.o $(OBJDIR)/vj_cascade_classifier.o $(OBJDIR)/vj_main.o

TEST_OBJS= $(OBJDIR)/vj_io.o $(OBJDIR)/vj_utils.o $(OBJDIR)/vj_tests.o

.PHONY: dirs clean

default: $(EXECUTABLE) $(TEST)

dirs:
	mkdir -p $(OBJDIR)/

clean:
	rm -rf $(OBJDIR) $(EXECUTABLE) $(TEST) *.pgm

$(EXECUTABLE): dirs $(EXEC_OBJS)
	$(CC) $(CFLAGS) -o $@ $(EXEC_OBJS)

$(TEST): dirs $(TEST_OBJS)
	$(CC) $(CFLAGS) -o $@ $(TEST_OBJS)

$(OBJDIR)/%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@

$(OBJDIR)/%.o: %.c
	$(CC) $< $(CFLAGS) -c -o $@


