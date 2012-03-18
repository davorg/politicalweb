SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `politicalweb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `politicalweb` ;

-- -----------------------------------------------------
-- Table `politicalweb`.`mp`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `politicalweb`.`mp` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `mp_name` VARCHAR(45) NULL DEFAULT NULL ,
  `twfy_id` INT(11) NOT NULL ,
  `twfy_mem_id` INT(11) NOT NULL ,
  `image_url` VARCHAR(200) NULL DEFAULT NULL ,
  `party` CHAR(30) NULL DEFAULT NULL ,
  `bbc_url` VARCHAR(100) NULL DEFAULT NULL ,
  `guardian_url` VARCHAR(100) NULL DEFAULT NULL ,
  `edm_url` VARCHAR(100) NULL DEFAULT NULL ,
  `wikipedia_url` VARCHAR(100) NULL DEFAULT NULL ,
  `official_site_url` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
AUTO_INCREMENT = 2590
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `politicalweb`.`constituency`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `politicalweb`.`constituency` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(100) NOT NULL ,
  `mp` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `mp` (`mp` ASC) ,
  CONSTRAINT `constituency_ibfk_1`
    FOREIGN KEY (`mp` )
    REFERENCES `politicalweb`.`mp` (`id` )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 1296
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `politicalweb`.`mp_link`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `politicalweb`.`mp_link` (
  `id` INT NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `url` VARCHAR(200) NULL ,
  `type` VARCHAR(45) NULL ,
  `mp` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_mp_link_1` (`mp` ASC) ,
  CONSTRAINT `fk_mp_link_1`
    FOREIGN KEY (`mp` )
    REFERENCES `politicalweb`.`mp` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `politicalweb`.`constituency_link`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `politicalweb`.`constituency_link` (
  `id` INT NOT NULL ,
  `description` VARCHAR(200) NULL ,
  `url` VARCHAR(200) NULL ,
  `type` VARCHAR(50) NULL ,
  `constituency` INT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_constituency_link_1` (`constituency` ASC) ,
  CONSTRAINT `fk_constituency_link_1`
    FOREIGN KEY (`constituency` )
    REFERENCES `politicalweb`.`constituency` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `politicalweb`.`user`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `politicalweb`.`user` (
  `id` INT NOT NULL ,
  `name` VARCHAR(45) NULL ,
  `password` VARCHAR(45) NULL ,
  `email` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `politicalweb`.`user_constituency`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `politicalweb`.`user_constituency` (
  `id` INT NOT NULL ,
  `user` INT NOT NULL ,
  `constituency` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_user_constituency_1` (`constituency` ASC) ,
  INDEX `fk_user_constituency_2` (`user` ASC) ,
  CONSTRAINT `fk_user_constituency_1`
    FOREIGN KEY (`constituency` )
    REFERENCES `politicalweb`.`constituency` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_constituency_2`
    FOREIGN KEY (`user` )
    REFERENCES `politicalweb`.`user` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
