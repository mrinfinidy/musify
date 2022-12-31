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
            default:
                pageTitle = 'Musify';
        }

        return pageTitle;
    }
}
