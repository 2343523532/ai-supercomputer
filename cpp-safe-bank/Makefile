CXX ?= g++
CXXFLAGS ?= -std=c++17 -Wall -Wextra -Wpedantic -O2
TARGET := cpp-safe-bank
SRC := src/main.cpp
HTTPLIB_DIR := third_party
HTTPLIB_H := $(HTTPLIB_DIR)/httplib.h
HTTPLIB_URL := https://raw.githubusercontent.com/yhirose/cpp-httplib/v0.18.3/httplib.h

.PHONY: all run clean fetch-httplib

all: $(TARGET)

$(HTTPLIB_H):
	mkdir -p $(HTTPLIB_DIR)
	curl -fsSL -o $(HTTPLIB_H) $(HTTPLIB_URL)

$(TARGET): $(SRC) $(HTTPLIB_H)
	$(CXX) $(CXXFLAGS) -I$(HTTPLIB_DIR) -o $@ $(SRC)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)

fetch-httplib: $(HTTPLIB_H)
