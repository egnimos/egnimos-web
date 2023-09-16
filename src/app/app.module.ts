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
import { CategoriesComponent } from './pages/profile/categories/categories.component';
import { EditprofileComponent } from './pages/profile/editprofile/editprofile.component';
import { ProfilearticlesComponent } from './pages/profile/profilearticles/profilearticles.component';

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
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MarkdownModule.forRoot(),
    HttpClientModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
