class PageTitle {
    static String getPageTitle(int currentPageIndex) {
        String pageTitle = '';
        
        switch (currentPageIndex) {
            case 0:
                pageTitle = 'Musify - Home';  
                break;
            case 1:
                pageTitle = 'Musify - Library';
                break;
            case 2:
                pageTitle = 'Musify - Settings';
                break;
            default:
                pageTitle = 'Musify';
        }

        return pageTitle;
    }
}
