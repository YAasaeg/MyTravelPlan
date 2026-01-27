export class Theme {
  // Colors - Swiss Spa Palette
  // Pure, clean, minimalist
  static readonly ColorBackground = '#F9FAFB'; // Very light gray, almost white
  static readonly ColorSurface = '#FFFFFF';
  static readonly ColorPrimary = '#2C3E50'; // Deep Blue Gray - Professional, High Value
  static readonly ColorSecondary = '#95A5A6'; // Calm Gray
  static readonly ColorAccent = '#D4AF37'; // Subtle Gold/Bronze for that "Luxury" feel (optional) or maybe just a clean #3498DB
  static readonly ColorTextPrimary = '#1A1A1A';
  static readonly ColorTextSecondary = '#7F8C8D';
  static readonly ColorBorder = '#E0E0E0';
  static readonly ColorError = '#E74C3C';

  // Spacing
  static readonly SpacingSmall = 8;
  static readonly SpacingMedium = 16;
  static readonly SpacingLarge = 24;
  static readonly SpacingXLarge = 32;

  // Radius
  static readonly RadiusSmall = 8;
  static readonly RadiusMedium = 16;
  static readonly RadiusLarge = 24;
  
  // Shadows (Soft, diffused)
  static readonly ShadowSoft = '0px 4px 12px rgba(0, 0, 0, 0.05)';
  static readonly ShadowMedium = '0px 8px 24px rgba(0, 0, 0, 0.08)';

  // Typography (Font Weights)
  static readonly FontWeightLight = 300;
  static readonly FontWeightRegular = 400;
  static readonly FontWeightMedium = 500;
  static readonly FontWeightBold = 700;
}

export default Theme;
