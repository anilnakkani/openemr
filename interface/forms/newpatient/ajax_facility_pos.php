<?php
	 // Copyright (C) 2012 Ensoftek 
	 // Author: Anil N
	 // This program is free software; you can redistribute it and/or
	 // modify it under the terms of the GNU General Public License
	 // as published by the Free Software Foundation; either version 2
	 // of the License, or (at your option) any later version.

	 //Ajax page for POS Code select box generation.
	 
	include_once("../../globals.php");
	include_once("../../../library/sql.inc");
	require_once("$srcdir/classes/POSRef.class.php");
	
	$facility_id = $_GET['facility_id'];
	$facilQry = "select pos_code,pos_code_multiple from facility where id='".add_escape_custom($facility_id)."'";
	$facilRes = sqlStatement($facilQry);
	$posCode = "";
	$optstr = "<select name='pos_code' id='pos_code'><option value=''>".xl('None')."</option>";
	 while($facilRow=sqlFetchArray($facilRes)){
		$posCode_def = $facilRow['pos_code'];
		$pos_multi = $facilRow['pos_code_multiple'];
		if($pos_multi != ""){
			$res = sqlStatement("select * from list_options where list_id='POS' and option_id in (".$pos_multi.")");
			$numrows = sqlNumRows($res);
			if($numrows > 0){
				while($posRow=sqlFetchArray($res)){
					$selMul = "";
					if($posRow['option_id'] == $posCode_def){
						$selMul = "selected";
					}
				
					$optstr .= "<option value='".$posRow['option_id']."' ".$selMul.">".$posRow['title']."</option>";
				}
			}
		}
	}
	$optstr .= "</select>";
	echo $optstr;
?>

