The browser will complete these steps to load a web page:

1. Find the target
2. Send a request
3. Process the headers
4. Process the message body
5. Create a page builder

# Processing the headers

1. If status code is a redirect, read the Location header and make a new HTTP request to the new URL.
2. Check the Content-Type header to determine the MIME type of the response.
3. If the response is HTML, continue with the HTML Processor
4. If the response is an image, continue with the Image Processor
5. If the response is Text, continue with the Text Processor
6. Otherwise, start a download
