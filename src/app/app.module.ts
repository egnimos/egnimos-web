import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

// COMPONENTS
import { HeaderComponent } from './components/header/header.component';
import { FooterComponent } from './components/footer/footer.component';

// PAGES
import { HomeComponent } from './pages/home/home.component';
import { AboutComponent } from './pages/about/about.component';
import { ContactComponent } from './pages/contact/contact.component';
import { AuthComponent } from './pages/auth/auth.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { PagenotfoundComponent } from './pages/pagenotfound/pagenotfound.component';
import { ArticlesComponent } from './pages/articles/articles.component';
import { MarkdownModule } from 'ngx-markdown';
import { HttpClientModule } from '@angular/common/http';
import { DraftsComponent } from './pages/profile/drafts/drafts.component';
import { CategoriesComponent } from './pages/categories/categories.component';
import { EditprofileComponent } from './pages/profile/editprofile/editprofile.component';
import { ProfilearticlesComponent } from './pages/profile/profilearticles/profilearticles.component';
import { EditorComponent } from './pages/editor/editor.component';
import { getApp, initializeApp, provideFirebaseApp } from '@angular/fire/app';
import { getAuth, provideAuth } from '@angular/fire/auth';
import { enableIndexedDbPersistence, enableMultiTabIndexedDbPersistence, enablePersistentCacheIndexAutoCreation, getFirestore, provideFirestore } from '@angular/fire/firestore';
import { getMessaging, provideMessaging } from '@angular/fire/messaging';
import { getPerformance, providePerformance } from '@angular/fire/performance';
import { getStorage, provideStorage } from '@angular/fire/storage';
import { environment } from 'src/environments/environment';
import { LoaderComponent } from './components/loader/loader.component';
import { CategoryBoxComponent } from './components/category-box/category-box.component';
import { FormsModule } from '@angular/forms';
import { Ng2ImgMaxModule } from 'ng2-img-max';
import { NgCircleProgressModule } from 'ng-circle-progress';
import { ArticleBoxComponent } from './components/article-box/article-box.component';
import { LottieModule } from 'ngx-lottie';
import player from 'lottie-web';
import { NothingFoundComponent } from './components/nothing-found/nothing-found.component';
import { EditorViewComponent } from './pages/editor/editor-view/editor-view.component';
import { ViewallComponent } from './pages/viewall/viewall.component';
import { BooksComponent } from './pages/profile/books/books.component';
import { CreateBookComponent } from './pages/profile/books/create-book/create-book.component';
import { CreateModuleComponent } from './pages/profile/books/create-book/create-module/create-module.component';
import { ModuleBoxComponent } from './components/module-box/module-box.component';
import { DragulaModule } from 'ng2-dragula';
import { BookBoxComponent } from './components/book-box/book-box.component';
import { ViewBookComponent } from './pages/view-book/view-book.component';
import { initializeFirestore, persistentLocalCache, persistentMultipleTabManager } from '@firebase/firestore';

@NgModule({
  declarations: [
    AppComponent,
    HeaderComponent,
    FooterComponent,
    HomeComponent,
    AboutComponent,
    ContactComponent,
    AuthComponent,
    ProfileComponent,
    PagenotfoundComponent,
    ArticlesComponent,
    DraftsComponent,
    CategoriesComponent,
    EditprofileComponent,
    ProfilearticlesComponent,
    EditorComponent,
    LoaderComponent,
    CategoryBoxComponent,
    ArticleBoxComponent,
    NothingFoundComponent,
    ViewallComponent,
    EditorViewComponent,
    BooksComponent,
    CreateBookComponent,
    CreateModuleComponent,
    ModuleBoxComponent,
    BookBoxComponent,
    ViewBookComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MarkdownModule.forRoot(),
    HttpClientModule,
    FormsModule,
    NgCircleProgressModule.forRoot(),
    Ng2ImgMaxModule,
    provideFirebaseApp(() => initializeApp(environment.firebase)),
    provideAuth(() => getAuth()),
    provideFirestore(() => initializeFirestore(getApp(), {
      localCache: persistentLocalCache({
        tabManager: persistentMultipleTabManager()
      })
    })),
    provideMessaging(() => getMessaging()),
    providePerformance(() => getPerformance()),
    provideStorage(() => getStorage()),
    LottieModule.forRoot({ player: playerFactory }),
    DragulaModule.forRoot()
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }


export function playerFactory() {
  return player;
}
