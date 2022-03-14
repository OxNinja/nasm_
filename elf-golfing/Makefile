default:
	make golf

golf: golf.s
	nasm -f bin golf.s -o golf
	chmod +x golf
	xxd golf
	wc -c golf

clean:
	rm -f golf
