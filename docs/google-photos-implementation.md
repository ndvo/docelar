# Google Photos Integration - Implementation

## Overview

Import photos from Google Photos to Doce Lar galleries.

## Implementation Steps

### Step 1: Setup OAuth 2.0

Create credentials:
```bash
# config/credentials.yml
google_photos:
  client_id: xxx
  client_secret: xxx
```

### Step 2: Create OAuth Controller

```ruby
# app/controllers/oauth/google_photos_controller.rb
class Oauth::GooglePhotosController < ApplicationController
  def callback
    # Store access token
    session[:google_photos_token] = params[:code]
    redirect_to galleries_path, notice: "Google Photos connected!"
  end

  def disconnect
    session.delete(:google_photos_token)
    redirect_to galleries_path, notice: "Google Photos disconnected"
  end
end
```

### Step 3: Add Routes

```ruby
# config/routes.rb
namespace :oauth do
  get :google_photos, to: 'google_photos#callback'
  delete :google_photos, to: 'google_photos#destroy'
end
```

### Step 4: Create Import Service

```ruby
# app/services/google_photos_import_service.rb
class GooglePhotosImportService
  def initialize(user)
    @user = user
  end

  def list_albums
    # Call Google Photos API
  end

  def import_photos(album_id, gallery_id)
    # Import photos from album to gallery
  end
end
```

### Step 5: Add Import Button to Gallery

```erb
<!-- app/views/galleries/_import_options.html.erb -->
<% if current_user.google_photos_connected? %>
  <%= button_to "Importar do Google Photos", 
      oauth_google_photos_path, 
      method: :get %>
<% else %>
  <%= link_to "Conectar Google Photos", 
      oauth_google_photos_path %>
<% end %>
```

## Files to Create

```
app/
├── controllers/
│   └── oauth/
│       └── google_photos_controller.rb
├── services/
│   └── google_photos_import_service.rb
├── models/
│   └── user.rb (add google_photos_token)
└── views/
    └── galleries/
        └── _import_options.html.erb
```

## Environment Variables

```
GOOGLE_CLIENT_ID=xxx
GOOGLE_CLIENT_SECRET=xxx
GOOGLE_REDIRECT_URI=http://localhost:3000/oauth/google_photos/callback
```

## Testing

1. **Unit**: GooglePhotosImportService methods
2. **Controller**: OAuth flow
3. **Feature**: Import button appears, import works

## Next Steps

1. [ ] Add Google API credentials
2. [ ] Create OAuth controller
3. [ ] Build import service
4. [ ] Add import button UI
5. [ ] Write tests
