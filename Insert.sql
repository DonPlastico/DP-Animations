CREATE TABLE `animaciones_favoritas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(50) NOT NULL,
  `nombre_animacion` VARCHAR(255) NOT NULL,
  `comando_animacion` VARCHAR(255) NOT NULL,
  `tipo_animacion` VARCHAR(50) NOT NULL,
  `fecha_guardado` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX (`identifier`)
);