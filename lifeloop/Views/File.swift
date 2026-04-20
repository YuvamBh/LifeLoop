# Commit 1
git add lifeloop/LoopViewModel.swift lifeloop/ReflectionViewModel.swift
git commit -m "fix: Add Combine import to ViewModels

- Import Combine framework in LoopViewModel and ReflectionViewModel
- Required for @Published property wrappers to compile
- Resolves 'Cannot find type @Published in scope' errors
- Ensures proper ObservableObject conformance"

# Commit 2
git add lifeloop/ProfileView.swift
git commit -m "feat: Add Profile View with user statistics

- Display comprehensive user stats dashboard
- Show total loops, completed loops, and total reflections
- Calculate and display average mood rating
- Add 'About This App' section with app description
- Use SwiftData @Query for real-time data updates
- Implement clean card-based UI with stat rows
- Phase 2 feature implementation"

# Commit 3
git add lifeloop/CommunityFeedView.swift
git commit -m "feat: Add Community Feed for sharing reflections

- Create community feed showing all user reflections
- Display reflection posts with loop title, text, and mood
- Add like/unlike functionality with heart icon
- Sort reflections by most recent first
- Show formatted timestamps for each post
- Empty state message when no posts exist
- Phase 2 feature implementation"

# Commit 4
git add lifeloop/MapScreenView.swift lifeloop/LocationViewModel.swift
git commit -m "feat: Add Map Screen with nearby places discovery

- Integrate MapKit for interactive map display
- Implement LocationViewModel with CLLocationManager
- Request and handle location permissions
- Fetch nearby places using GeoNames API
- Display user location and nearby cities on map
- Show place details with population and country info
- Add selectable place markers and region focusing
- Handle loading states and error messages
- Phase 2 feature implementation"

# Commit 5
git add lifeloop/ContentView.swift
git commit -m "feat: Add TabView navigation with Phase 2 features

- Implement TabView with 4 main sections
- Add Home tab (existing growth loops)
- Add Community tab (reflection feed)
- Add Map tab (nearby locations)
- Add Profile tab (user statistics)
- Use SF Symbols for tab icons
- Wrap each tab in NavigationStack
- Complete Phase 2 navigation structure"

# Push everything
git push origin main
