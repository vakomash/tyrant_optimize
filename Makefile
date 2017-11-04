MAIN := tuo.exe
SRCS := $(wildcard *.cpp)
OBJS := $(patsubst %.cpp,obj/%.o,$(SRCS))
INCS := $(wildcard *.h)

CPPFLAGS := -Wall -Werror -std=gnu++11 -Ofast -DNDEBUG -DNQUEST -DTYRANT_OPTIMIZER_VERSION='"$(shell git describe --tags --abbrev=0 --dirty)"'
LDFLAGS := -lboost_system -lboost_thread -lboost_filesystem -lboost_regex

all: $(MAIN)

obj/%.o: %.cpp $(INCS)
	-@if not exist "obj" mkdir "obj"
	$(CXX) $(CPPFLAGS) -o $@ -c $<

$(MAIN): $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

reuild: clean all

clean:
	del /q $(MAIN).exe obj\*.o
