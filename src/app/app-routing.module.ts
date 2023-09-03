import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { AboutComponent } from './about/about.component';
import { ContactComponent } from './contact/contact.component';
import { PagenotfoundComponent } from './pagenotfound/pagenotfound.component';
import { AuthComponent } from './auth/auth.component';
import { ArticlesComponent } from './articles/articles.component';
import { ProfileComponent } from './profile/profile.component';

const routes: Routes = [
  { path: "", component: HomeComponent },
  { path: "about", component: AboutComponent },
  { path: "auth", component: AuthComponent },
  { path: "profile", component: ProfileComponent },
  { path: "articles", component: ArticlesComponent },
  { path: "contact", component: ContactComponent },
  { path: "not-found", component: PagenotfoundComponent },
  { path: "**", redirectTo: "/not-found", pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
