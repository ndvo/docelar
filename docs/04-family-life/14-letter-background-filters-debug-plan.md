# Letter Background Filters - Debug Plan

## Problem
Image filters not working - preview returns 422 or image doesn't change.

## Diagnostic Approach

### 1. What We Know (Evidence)
- Filter save to DB works (logs show filters stored)
- Preview endpoint returns 422 errors
- ImageMagick commands fail with "unrecognized intensity" and other syntax errors

### 2. Hypotheses (Possible Causes)

| # | Hypothesis | Evidence | Test |
|---|------------|----------|------|
| A | ImageMagick syntax wrong | `mogrify -grayscale` fails with "unrecognized" | Test mini_magick in isolation |
| B | Parameter passing wrong | Error shows params as image files `0` and `0.6` | Check apply_filter params |
| C | Filter config corrupted | JSON stored with wrong key types (string vs symbol) | Check filter_stack format |
| D | Memory/garbage collection | Files created but not written | Check output file size |
| E | Version incompatibility | mini_magick API changed | Check gem version |

### 3. TDD Approach - Write Tests First

```ruby
# spec/services/image_filter_service_spec.rb

describe ImageFilterService do
  let(:test_image_path) { "spec/fixtures/test_image.png" }
  
  before do
    # Create a test image using ImageMagick directly
    system "convert -size 100x100 xc:blue #{test_image_path}"
  end
  
  after do
    File.delete(test_image_path) if File.exist?(test_image_path)
  end

  describe "apply_filter" do
    it "applies blur without error" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filter(image, { type: "blur", params: { sigma: 2 } })
      expect(result).to be_a(MiniMagick::Image)
    end
    
    it "applies grayscale without error" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filter(image, { type: "grayscale", params: {} })
      expect(result).to be_a(MiniMagick::Image)
    end
    
    it "applies sepia without error" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filter(image, { type: "sepia", params: {} })
      expect(result).to be_a(MiniMagick::Image)
    end
    
    it "applies contrast without error" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filter(image, { type: "contrast", params: { contrast: 1.3 } })
      expect(result).to be_a(MiniMagick::Image)
    end
    
    it "applies negate without error" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filter(image, { type: "negate", params: {} })
      expect(result).to be_a(MiniMagick::Image)
    end
  end

  describe "apply_filters" do
    it "applies multiple filters in sequence" do
      image = MiniMagick::Image.open(test_image_path)
      filters = [
        { type: "grayscale", params: {} },
        { type: "contrast", params: { contrast: 1.3 } }
      ]
      result = described_class.apply_filters(image, filters)
      expect(result).to be_a(MiniMagick::Image)
    end
    
    it "handles empty filter array" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filters(image, [])
      expect(result).to be_a(MiniMagick::Image)
    end
    
    it "handles nil filters" do
      image = MiniMagick::Image.open(test_image_path)
      result = described_class.apply_filters(image, nil)
      expect(result).to be_a(MiniMagick::Image)
    end
  end
end
```

### 4. Unit Test for Controller

```ruby
# spec/requests/letter_backgrounds_preview_spec.rb

describe "LetterBackgroundsController#preview" do
  let(:user) { create(:user) }
  let(:letter_background) { create(:letter_background, user:) }
  
  before { sign_in user }
  
  context "with no filters" do
    it "returns original image" do
      get :preview, params: { id: letter_background.id }
      expect(response).to be_successful
    end
  end
  
  context "with blur filter" do
    before do
      letter_background.add_filter("blur", { sigma: 2 })
      letter_background.save!
    end
    
    it "returns 200" do
      get :preview, params: { id: letter_background.id }
      expect(response).to have_http_status(:ok)
    end
    
    it "returns PNG" do
      get :preview, params: { id: letter_background.id }
      expect(response.media_type).to eq("image/png")
    end
  end
  
  context "with multiple filters" do
    before do
      letter_background.add_filter("grayscale", {})
      letter_background.add_filter("contrast", { contrast: 1.3 })
      letter_background.add_filter("blur", { sigma: 1 })
      letter_background.save!
    end
    
    it "returns 200" do
      get :preview, params: { id: letter_background.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
```

### 5. Logging Strategy

Add structured logging:

```ruby
# app/services/image_filter_service.rb

class ImageFilterService
  def self.apply_filter(image, filter)
    type = filter[:type]
    params = filter[:params] || {}
    
    Rails.logger.info "ImageFilter: applying #{type} with params #{params}"
    
    result = send("apply_#{type}", image, params)
    
    # Log the resulting image dimensions/colorspace
    Rails.logger.info "ImageFilter: result dims=#{result.width}x#{result.height}, colorspace=#{result.colorspace}"
    
    result
  rescue => e
    Rails.logger.error "ImageFilter ERROR: #{e.message} for filter #{type}"
    raise
  end
end
```

### 6. Immediate Next Steps

1. **Write passing spec first** - Get one filter working in isolation
2. **Fix grammar in mini_magick calls** - Use correct syntax per version
3. **Add request spec** - Test preview endpoint with filters
4. **Add error handling** - Return error image instead of 500

### 7. Code Quality Issues to Fix

- Too many rescue clauses swallowing errors
- Missing spec coverage
- No isolation tests
- Debug logs not structured