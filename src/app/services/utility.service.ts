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

    secondsToDateTime(seconds: number): Date {
        // Multiply seconds by 1000 to get milliseconds
        const milliseconds = seconds * 1000;

        // Create a new Date object with the milliseconds
        const date = new Date(milliseconds);

        return date;
    }

    timeAgo(date) {
        const seconds = Math.floor((new Date().getDate() - date) / 1000);

        let interval = Math.floor(seconds / 31536000);
        if (interval > 1) {
            return interval + ' years ago';
        }

        interval = Math.floor(seconds / 2592000);
        if (interval > 1) {
            return interval + ' months ago';
        }

        interval = Math.floor(seconds / 86400);
        if (interval > 1) {
            return interval + ' days ago';
        }

        interval = Math.floor(seconds / 3600);
        if (interval > 1) {
            return interval + ' hours ago';
        }

        interval = Math.floor(seconds / 60);
        if (interval > 1) {
            return interval + ' minutes ago';
        }

        if (seconds < 10) return 'just now';

        return Math.floor(seconds) + ' seconds ago';
    };

    enumToString(enumType: any, value: any): String | undefined {
        const keys = Object.keys(enumType).filter(key => enumType[key] === value);
        return keys.length > 0 ? keys[0] : undefined;
    }

    // stringToEnum(enumType: any, value: String): any {
    //     const keys = Object.values(enumType).filter(val => enumType[val] === value);
    //     return keys.length > 0 ? keys[0] : undefined;
    // }
}