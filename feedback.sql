
CREATE TABLE IF NOT EXISTS `organization` (
  `name` VARCHAR(16) NOT NULL,
  `id` INT NOT NULL,
  `address` VARCHAR(255) NULL,
  `create_time` DATETIME  NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `user` (
  `name` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(32) NULL,
  `create_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT NOT NULL,
  `org_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `org_id_idx` (`org_id` ASC),
  CONSTRAINT `org_id`
    FOREIGN KEY (`org_id`)
    REFERENCES `organization` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS `feedback` (
  `feedback_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`, `user_id`),
  INDEX `userid_idx` (`user_id` ASC),
  CONSTRAINT `userid`
    FOREIGN KEY (`user_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS `survey` (
  `survey_id` INT NOT NULL,
  `feedback_id` INT NOT NULL,
  `submitter_id` INT NULL,
  `submitted_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`survey_id`, `feedback_id`),
  INDEX `feedback_id_idx` (`feedback_id` ASC),
  INDEX `submitter_id_idx` (`submitter_id` ASC),
  CONSTRAINT `feedback_id`
    FOREIGN KEY (`feedback_id`)
    REFERENCES `feedback` (`feedback_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `submitter_id`
    FOREIGN KEY (`submitter_id`)
    REFERENCES `user` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS `question` (
  `question_id` INT NOT NULL,
  `question_desc` VARCHAR(250) NULL,
  PRIMARY KEY (`question_id`));

CREATE TABLE IF NOT EXISTS `question_org_map` (
  `question_id` INT NOT NULL,
  `o_id` INT NULL,
  PRIMARY KEY (`question_id`, `o_id`),
  INDEX `org_id_idx` (`o_id` ASC),
  CONSTRAINT `question_id`
    FOREIGN KEY (`question_id`)
    REFERENCES `question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `o_id`
    FOREIGN KEY (`o_id`)
    REFERENCES `organization` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
CREATE TABLE IF NOT EXISTS `survey_answers` (
  `survey_id` INT NOT NULL,
  `qst_id` INT NOT NULL,
  `answer` INT NULL,
  PRIMARY KEY (`survey_id`, `qst_id`),
  INDEX `qst_id_idx` (`qst_id` ASC),
  CONSTRAINT `survey_id`
    FOREIGN KEY (`survey_id`)
    REFERENCES `survey` (`survey_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `qst_id`
    FOREIGN KEY (`qst_id`)
    REFERENCES `question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
Insert into organization(name,id) values("Lifion","1");

Insert into user(name,user_id,org_id) values ("John",1,1);
Insert into user(name,user_id,org_id) values ("Abi",2,1);
Insert into user(name,user_id,org_id) values ("Mary",3,1);

Insert into feedback(feedback_id,user_id) values (1,1);

Insert into survey(survey_id,feedback_id,submitter_id) values (1,1,3);

Insert into question(question_id, question_desc) values (1,"Rate my timeliness");
Insert into question(question_id, question_desc) values (2,"Rate my overall work");

Insert into survey_answers(survey_id, qst_id, answer) values (1,1,5);
Insert into survey_answers(survey_id, qst_id, answer) values (1,2,4);


#End of DDL#

#A database query based on the above data model design, that if given a 
#particular Survey ID would return the question text, submitter response, 
#and the name of the submitter. 

SELECT u.name, q.question_desc, sa.answer 
FROM survey AS s 
     INNER JOIN survey_answers AS sa 
         ON s.survey_id = sa.survey_id
     INNER JOIN question as q
         ON sa.qst_id = q.question_id
     INNER JOIN user as u
         ON s.submitter_id = u.user_id;



