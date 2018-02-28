-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema tododb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tododb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tododb` DEFAULT CHARACTER SET utf8 ;
USE `tododb` ;

-- -----------------------------------------------------
-- Table `tododb`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`users` (
  `id_user` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `avatar` VARCHAR(255) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `token` VARCHAR(200) NULL,
  `token_expiration` DATETIME NULL,
  PRIMARY KEY (`id_user`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  UNIQUE INDEX `token_UNIQUE` (`token` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`cards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`cards` (
  `id_card` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `priority` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `deadline` DATETIME NOT NULL,
  `category` VARCHAR(255) NULL,
  PRIMARY KEY (`id_card`),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`tasks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`tasks` (
  `id_task` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `rank` INT NOT NULL,
  `cards_id_card` INT NOT NULL,
  PRIMARY KEY (`id_task`),
  INDEX `fk_tasks_cards1_idx` (`cards_id_card` ASC),
  CONSTRAINT `fk_tasks_cards1`
    FOREIGN KEY (`cards_id_card`)
    REFERENCES `tododb`.`cards` (`id_card`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`groups` (
  `id_group` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`id_group`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`logs` (
  `id_log` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  `date` DATETIME NOT NULL,
  `cards_id_card` INT NOT NULL,
  `users_id_user` INT NOT NULL,
  `content` TEXT NULL,
  PRIMARY KEY (`id_log`),
  INDEX `fk_logs_cards1_idx` (`cards_id_card` ASC),
  INDEX `fk_logs_users1_idx` (`users_id_user` ASC),
  CONSTRAINT `fk_logs_cards1`
    FOREIGN KEY (`cards_id_card`)
    REFERENCES `tododb`.`cards` (`id_card`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_logs_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `tododb`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`properties`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`properties` (
  `id_property` INT NOT NULL AUTO_INCREMENT,
  `filter_perso` VARCHAR(45) NOT NULL,
  `filter_general` VARCHAR(45) NOT NULL,
  `rank` INT NOT NULL,
  `rights` VARCHAR(255) NULL,
  `cards_id_card` INT NOT NULL,
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`id_property`),
  INDEX `fk_properties_cards1_idx` (`cards_id_card` ASC),
  INDEX `fk_properties_users1_idx` (`users_id_user` ASC),
  CONSTRAINT `fk_properties_cards1`
    FOREIGN KEY (`cards_id_card`)
    REFERENCES `tododb`.`cards` (`id_card`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_properties_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `tododb`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`cards_has_groups`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`cards_has_groups` (
  `cards_id_card` INT NOT NULL,
  `groups_id_group` INT NOT NULL,
  PRIMARY KEY (`cards_id_card`, `groups_id_group`),
  INDEX `fk_cards_has_groups_groups1_idx` (`groups_id_group` ASC),
  INDEX `fk_cards_has_groups_cards1_idx` (`cards_id_card` ASC),
  CONSTRAINT `fk_cards_has_groups_cards1`
    FOREIGN KEY (`cards_id_card`)
    REFERENCES `tododb`.`cards` (`id_card`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cards_has_groups_groups1`
    FOREIGN KEY (`groups_id_group`)
    REFERENCES `tododb`.`groups` (`id_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tododb`.`groups_has_users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tododb`.`groups_has_users` (
  `groups_id_group` INT NOT NULL,
  `users_id_user` INT NOT NULL,
  PRIMARY KEY (`groups_id_group`, `users_id_user`),
  INDEX `fk_groups_has_users_users1_idx` (`users_id_user` ASC),
  INDEX `fk_groups_has_users_groups1_idx` (`groups_id_group` ASC),
  CONSTRAINT `fk_groups_has_users_groups1`
    FOREIGN KEY (`groups_id_group`)
    REFERENCES `tododb`.`groups` (`id_group`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_groups_has_users_users1`
    FOREIGN KEY (`users_id_user`)
    REFERENCES `tododb`.`users` (`id_user`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
