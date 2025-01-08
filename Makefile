# Nom du programme à construire
TARGET = esme-gpio-toggle

# Répertoire d'installation
INSTALL_DIR ?= ./install/usr/bin

# Variables de compilation
CFLAGS += $(shell pkg-config --cflags libgpiod)
LDLIBS += $(shell pkg-config --libs libgpiod)

# Fichiers source
SRCS = esme-gpio-toggle.c
OBJS = $(SRCS:.c=.o)

# Compiler et lier le programme
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LDLIBS)

# Règle d'installation
install: $(TARGET)
	@mkdir -p $(INSTALL_DIR)
	@cp $(TARGET) $(INSTALL_DIR)

# Règle de nettoyage
clean:
	@rm -f $(OBJS) $(TARGET)

# Règle par défaut
.PHONY: all
all: $(TARGET)

# Règle pour la création des objets
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

