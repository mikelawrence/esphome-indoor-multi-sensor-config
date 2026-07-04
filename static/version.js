fetch('./firmware/multi-sensor-pkga-ld2410.manifest.json')
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
    })
    .then(manifest => {
        // Insert the specific JSON values into your HTML elements
        document.getElementById('current-version').textContent = manifest.version;
    })
    .catch(error => {
        console.error('There was a problem with the fetch operation:', manifest);
        // document.getElementById('name-placeholder').textContent = 'Failed to load data';
    });
