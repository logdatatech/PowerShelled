#https://stackoverflow.com/questions/417435/how-can-i-search-for-a-varying-string-in-an-xml-file-using-vbs-and-replace-it-wi
(Get-Content doc.xml) -replace '<a>.*</a>','<a></a>' | Set-Content doc.xml