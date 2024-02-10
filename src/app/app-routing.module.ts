import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { AboutComponent } from './pages/about/about.component';
import { ContactComponent } from './pages/contact/contact.component';
import { PagenotfoundComponent } from './pages/pagenotfound/pagenotfound.component';
import { AuthComponent } from './pages/auth/auth.component';
import { ArticlesComponent } from './pages/articles/articles.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { DraftsComponent } from './pages/profile/drafts/drafts.component';
import { CategoriesComponent } from './pages/categories/categories.component';
import { EditprofileComponent } from './pages/profile/editprofile/editprofile.component';
import { ProfilearticlesComponent } from './pages/profile/profilearticles/profilearticles.component';
import { EditorComponent } from './pages/editor/editor.component';
import { EditorViewComponent } from './pages/editor/editor-view/editor-view.component';
import { ViewallComponent } from './pages/viewall/viewall.component';
import { CreateBookComponent } from './pages/profile/books/create-book/create-book.component';
import { BooksComponent } from './pages/profile/books/books.component';
import { CreateModuleComponent } from './pages/profile/books/create-book/create-module/create-module.component';
import { ViewBookComponent } from './pages/view-book/view-book.component';

const routes: Routes = [
  { path: "", component: HomeComponent },
  { path: "about", component: AboutComponent },
  {
    path: "profile", component: ProfileComponent, children: [
      { path: "", component: ProfilearticlesComponent },
      { path: "drafts", component: DraftsComponent },
      { path: "books", component: BooksComponent },
      { path: "edit-profile", component: EditprofileComponent },
    ]
  },
  //BOOKS
  {
    path: "book", children: [
      { path: "view-book", component: ViewBookComponent },
      { path: "create-module", component: CreateModuleComponent },
      { path: "create-book", component: CreateBookComponent },
    ]
  },
  { path: "categories", component: CategoriesComponent },
  { path: "view_all_category_based_articles/:type", component: ViewallComponent },
  { path: "write-article", component: EditorComponent },


  { path: "view-article", component: EditorViewComponent },
  { path: "articles", component: ArticlesComponent },
  { path: "contact", component: ContactComponent },
  { path: "not-found", component: PagenotfoundComponent },
  { path: "auth", component: AuthComponent },
  { path: "**", redirectTo: "/not-found", pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
