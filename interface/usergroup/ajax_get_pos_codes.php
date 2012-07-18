<?php
	// Copyright (C) 2012 Ensoftek 
	// Author: Anil N
	// This program is free software; you can redistribute it and/or
	// modify it under the terms of the GNU General Public License
	// as published by the Free Software Foundation; either version 2
	// of the License, or (at your option) any later version.

	//Ajax page for get all POS Codes in select box.
	
	
	include_once("../globals.php");
	include_once("../../library/sql.inc");

	$poslists = $_GET['posarr'];
	
	$res = sqlStatement("select * from list_options where list_id='POS' and option_id in (".$poslists.")");
	$numrows = sqlNumRows($res);
	$optstr = "<select name='pos_code' id='pos_code'><option value=''>".xl('None')."</option>";
	if($numrows > 0){
		while($posRow=sqlFetchArray($res)){
			$optstr .= "<option value='".$posRow['option_id']."'>".$posRow['title']."</option>";
		}
	}
	$optstr .= "</select>";
	
	echo $optstr;
?>