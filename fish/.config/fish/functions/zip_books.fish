function zip_books
   set books_dir "/Users/sanufar/books"
   if test "$PWD" = "$books_dir"
	echo "Zipping books:"
	zip books ./*.pdf
	ls -l1 | grep .pdf > books.txt
   end
end
