import autoComplete from "@tarekraafat/autocomplete.js/dist/js/autoComplete";
// Fetch External Data Source
new autoComplete({
    data: {                              // Data src [Array, Function, Async] | (REQUIRED)
        src: async () => {
        // User search query
        const query = document.querySelector("#autoComplete").value;
        // Fetch External Data Source
        const source = await fetch(`/books.json?q=${query}`);
        // Format data into JSON
        const data = await source.json();
        // Return Fetched data
        return data;
        },
        key: ["title", "authors", "year", "genre", "language", "spot", "isbn", "abstract", "code"],
        cache: false
    },
    placeHolder: "Books...",     // Place Holder text                 | (Optional)
    selector: "#autoComplete",           // Input field selector              | (Optional)
    observer: true,                      // Input field observer | (Optional)
    threshold: 1,                        // Min. Chars length to start Engine | (Optional)
    debounce: 700,                       // Post duration for engine to start | (Optional)
    searchEngine: "strict",              // Search Engine type/mode           | (Optional)
    resultsList: {                       // Rendered results list object      | (Optional)
        container: source => {
            source.setAttribute("id", "book_list");
        },
        destination: "#autoComplete",
        position: "afterend",
        element: "ul"
    },
    maxResults: 5,                         // Max. number of rendered results | (Optional)
    highlight: true,                       // Highlight matching results      | (Optional)
    resultItem: {                          // Rendered result item            | (Optional)
        content: (data, source) => {
            const book = data.value
            source.innerHTML = book.title + " - " + book.genre + " - " + book.year + " - " + book.isbn + " - " + book.code
        },
        element: "li"
    },

    onSelection: feedback => {             // Action script onSelection event | (Optional)
        const book = feedback.selection.value
        document.getElementById("loan_book_id").value = book.id.$oid
        document.getElementById("book_title").value = book.title
    }
});