import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { AboutComponent } from './pages/about/about.component';
import { ContactComponent } from './pages/contact/contact.component';
import { PagenotfoundComponent } from './pages/pagenotfound/pagenotfound.component';
import { AuthComponent } from './pages/auth/auth.component';
import { ArticlesComponent } from './pages/articles/articles.component';
import { ProfileComponent } from './pages/profile/profile.component';

const routes: Routes = [
  { path: "", component: HomeComponent },
  { path: "about", component: AboutComponent },
  { path: "profile", component: ProfileComponent },
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
