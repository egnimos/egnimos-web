class InlineFontFamily {
    nodes: { wrapper: any; select: any; };
    api: any;
    inlineToolbar: any;
    constructor({ api }) {
        this.api = api;
        this.inlineToolbar = null;
        this.nodes = {
            wrapper: null,
            select: null,
        };
    }

    static isInline = true

    render() {
        this.nodes.wrapper = document.createElement('div');
        this.nodes.select = document.createElement('select');

        // Define font family options
        const fontFamilies = ['Arial', 'Verdana', 'Times New Roman', 'Courier New', 'Georgia'];

        // Create and append options to the select element
        fontFamilies.forEach((family) => {
            const option = document.createElement('option');
            option.text = family;
            option.value = family;
            this.nodes.select.appendChild(option);
        });

        this.nodes.select.addEventListener('change', () => {
            this.applyFontFamily();
        });

        this.nodes.wrapper.appendChild(this.nodes.select);

        return this.nodes.wrapper;
    }

    applyFontFamily() {
        const selectedFont = this.nodes.select.value;
        this.api.selection.expandTo(this.inlineToolbar.targetElement);
        document.execCommand('fontName', false, selectedFont);
    }
}

InlineFontFamily.isInline = true;

export default InlineFontFamily;
