--Manually Log into Clinic website. Download statement PDF to Downloads folder.
--theFile set by Hazel (Downloads folder)

--PDFpen OCR routine modified from http://www.documentsnap.com/pdfpen-ocr-applescript-to-automatically-make-pdfs-searchable/

tell application "PDFpen"
	
	open theFile
	
	tell document 1
		ocr
		repeat while performing ocr
			delay 1
		end repeat
		delay 1
		set thePlainText to plain text
		close with saving
		--quit saving yes
	end tell
end tell

set listVar to every paragraph of thePlainText

set saveStatmentDateLine to ""
repeat with nextLine in listVar
	if length of nextLine is greater than 0 then
		-- Assuming (!) the OCR succeeds in deciphering "Statement Date: MMM DD, YYYY" on the first occurrence of "Statement Date"
		-- TODO: error handling?
		if nextLine contains "Statement Date" then
			set saveStatementDateLine to nextLine
			exit repeat
		end if
	end if
end repeat

-- Assuming (!) the OCR succeeds in deciphering "Statement Date: MMM DD, YYYY"
-- TODO: error handling?
-- This sed/awk mess translates strips the comma and translates Jan into 01, Feb into 02, etc. Returns YYYY_MM_DD for proper sorting in Finder
set theDate to do shell script "echo " & saveStatementDateLine & " | sed -e 's/,//' -e 's;Jan;01;' -e 's;Feb;02;' -e 's;Mar;03;' -e 's;Apr;04;' -e 's;May;05;' -e 's;Jun;06;' -e 's;Jul;07;' -e 's;Aug;08;' -e 's;Sep;09;' -e 's;Oct;10;' -e 's;Nov;11;' -e 's;Dec;12;' | awk '{printf \"%d_%d_%d\", $5,$3,$4}'"

tell application "Finder"
	
	set parentFolder to container of (theFile as alias)

	--TODO: enhance to file in a new folder via .../YYYY/...

	set newName to "ClinicStatement_" & theDate & ".pdf"
	set name of file theFile to newName
	
end tell