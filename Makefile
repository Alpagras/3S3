# Définir le répertoire d'installation par défaut
INSTALL_DIR ?= ./install

# Cibles de compilation
CFLAGS += $(shell pkg-config --cflags libgpiod)
LDLIBS += $(shell pkg-config --libs libgpiod)

# Nom du programme à construire
TARGET = esme-gpio-toggle

# Compilation des sources
$(TARGET): esme-gpio-toggle.o
	$(CC) -o $(TARGET) esme-gpio-toggle.o $(LDLIBS)

# Compilation des objets
esme-gpio-toggle.o: esme-gpio-toggle.c
	$(CC) -c esme-gpio-toggle.c -o esme-gpio-toggle.o $(CFLAGS)

# Installer le programme et le script de démarrage
install: $(TARGET)
	# Créer le répertoire d'installation si nécessaire
	mkdir -p $(INSTALL_DIR)/usr/bin
	# Copier le programme compilé dans /usr/bin
	cp $(TARGET) $(INSTALL_DIR)/usr/bin/
	# Copier le script d'init.d dans /etc/init.d et définir les permissions
	mkdir -p $(INSTALL_DIR)/etc/init.d
	cp esme-gpio26-toggle $(INSTALL_DIR)/etc/init.d/
	chmod 0755 $(INSTALL_DIR)/etc/init.d/esme-gpio26-toggle

# Nettoyer les fichiers générés
clean:
	rm -f $(TARGET) esme-gpio-toggle.o

# Cibles par défaut
.PHONY: install clean
