export enum FetchingStatus {
    loading = "loading",
    complete = "complete",
    error = "error",
    unknown = "unknown",
}

export enum UploadStatus {
    uploading = "uploading",
    error = "error",
    complete = "complete",
}

export enum PublishType {
    publish = "publish",
    draft = "draft",
}

export enum EditorType {
    quill = "quill",
    editorjs = "editorjs",
}

export enum ProviderType {
    github = "github.com",
    google = "google.com",
    unknown = "unknown",
}

export enum Gender {
    male = "male",
    female = "female",
    RatherNotToSay = "Rather Not To Say",
}

export enum AccountType {
    Adult = "Adult",
    Child = "Child",
}

export enum ViewAllType {
    category = 'category',
    sessonalquiz = 'sessonalquiz',
    normalquiz = 'normalquiz',
    categorybasedQuiz = 'categorybasedQuiz',
    unknown = 'unknown'
}