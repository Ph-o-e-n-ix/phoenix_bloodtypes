CREATE TABLE IF NOT EXISTS `phoenix_bloodtypes` (
  `identifier` varchar(46) DEFAULT NULL,
  `name` varchar(25) DEFAULT NULL,
  `bloodtype` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
	('blood_ap', 'Blood A+', 1, 0, 1),
	('blood_0p', 'Blood 0+', 1, 0, 1),
	('blood_bp', 'Blood B+', 1, 0, 1),
	('blood_an', 'Blood A-', 1, 0, 1),
	('blood_0n', 'Blood 0-', 1, 0, 1),
	('blood_abp', 'Blood AB+', 1, 0, 1),
	('blood_bn', 'Blood B+', 1, 0, 1),
	('blood_abn', 'Blood AB-', 1, 0, 1),
	('blood_test', 'Blood tester', 1, 0, 1),
	('syringe', 'Syringe', 1, 0, 1),
	('blood_empty', 'Empty Bloodpack', 1, 0, 1);