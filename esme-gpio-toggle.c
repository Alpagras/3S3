#include <gpiod.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define DEFAULT_GPIO 26 

int main(int argc, char *argv[]) {
    int gpio_id = DEFAULT_GPIO; // GPIO par défaut
    struct gpiod_chip *chip; // Déclaration de la variable chip
    struct gpiod_line *line; // Déclaration de la variable line
    struct gpiod_line_request_config config; // Déclaration de la variable config
    int value = 0; // Déclaration de la variable value 

    // Vérification des arguments de ligne de commande
    if (argc > 2 && strcmp(argv[1], "--gpio") == 0) {
        gpio_id = atoi(argv[2]);
    }

    // Ouverture du chip GPIO
    chip = gpiod_chip_open("/dev/gpiochip0");
    if (!chip) {
        perror("Erreur lors de l'ouverture du chip GPIO");
        return EXIT_FAILURE;
    }

    // Obtention de la ligne GPIO
    line = gpiod_chip_get_line(chip, gpio_id);
    if (!line) {
        perror("Erreur lors de l'obtention de la ligne GPIO");
        gpiod_chip_close(chip);
        return EXIT_FAILURE;
    }

    // Configuration de la ligne en sortie
    memset(&config, 0, sizeof(config));
    config.consumer = "esme-gpio-toggle";
    config.request_type = GPIOD_LINE_REQUEST_DIRECTION_OUTPUT;

	if (gpiod_line_request_output(line, "esme-gpio-toggle", value) < 0) {
    perror("Erreur lors de la demande de sortie sur la ligne GPIO");
    gpiod_line_release(line);
    gpiod_chip_close(chip);
    return EXIT_FAILURE;
}


    // Boucle infinie pour inverser l'état de la LED
    while (1) {
        value = !value; // Inverser la valeur
        if (gpiod_line_set_value(line, value) < 0) {
            perror("Erreur lors de la définition de la valeur de la ligne GPIO");
            break;
        }
        sleep(1); // Attendre une seconde
    }

    // Libération des ressources
    gpiod_line_release(line);
    gpiod_chip_close(chip);

    return EXIT_SUCCESS;
}
