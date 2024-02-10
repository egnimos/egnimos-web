import { Injectable } from "@angular/core";

@Injectable({
    providedIn: 'root',
})
export class CacheService {
    //cache metadata

    //set the cache
    set(meta: CacheMeta) {
        sessionStorage.setItem(meta.id, JSON.stringify(meta));
    }

    //get the cache
    get(key): CacheMeta {
        return JSON.parse(sessionStorage.getItem(key)) as CacheMeta;
    }
}

export interface CacheMeta {
    id: string,
    isCached: Boolean,
    change: Boolean,
}