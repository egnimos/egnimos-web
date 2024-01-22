import { Injectable } from "@angular/core";

@Injectable({
    providedIn: 'root',
})
export class UtilityService {
    constructor() {

    }

    createSearchList(keyword: String) {
        const keywordSize = keyword?.length ?? 0
        let result = []
        for (let i = 0; i <= keywordSize; i++) {
            if (i === 0) continue;
            result.push(keyword.slice(0, i))
        }
        return result
    }

    getRandomDarkerColor(): string {
        // Generate random values for red, green, and blue components
        const red = Math.floor(Math.random() * 256); // Random value between 0 and 255
        const green = Math.floor(Math.random() * 256); // Random value between 0 and 255
        const blue = Math.floor(Math.random() * 256); // Random value between 0 and 255

        // Create a random darkness factor between 0.5 and 0.9
        const darknessFactor = Math.random() * (0.9 - 0.5) + 0.5;

        // Calculate darker color values by applying the darkness factor
        const darkerRed = Math.floor(red * darknessFactor);
        const darkerGreen = Math.floor(green * darknessFactor);
        const darkerBlue = Math.floor(blue * darknessFactor);

        // Construct the darker color using RGB values
        const darkerColor = `rgb(${darkerRed}, ${darkerGreen}, ${darkerBlue})`;

        return darkerColor;
    }

    enumToString(enumType: any, value: any): string | undefined {
        const keys = Object.keys(enumType).filter(key => enumType[key] === value);
        return keys.length > 0 ? keys[0] : undefined;
    }
}