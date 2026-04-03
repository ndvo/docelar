# Photo Show Page Improvement Plan

## Issues Identified

1. **No gallery indication** - No indication on what gallery the photo is in
2. **No looping navigation** - When reaching last photo, no "next" button (should loop to first)
3. **No position indicator** - No visual clue where we are in the list (start? end?)
4. **Tag field styling** - Tag field looks weird
5. **No swipe navigation** - Can't swipe to next photo on phone
6. **Photo size** - Photo could cover more of the screen

## High Priority

- [ ] 1. Add gallery breadcrumb/indication
- [ ] 2. Make navigation circular (last → first, first → last)
- [ ] 3. Add position indicator (e.g., "3 de 15")
- [ ] 4. Fix tag input styling
- [ ] 5. Add swipe gesture support for mobile
- [ ] 6. Increase photo size on screen

## Implementation Notes

- Use Turbo/TurboFrames for smooth navigation
- Add progress indicator bar or text
- Use CSS touch-action for swipe gestures
- Consider keyboard navigation (arrow keys)
