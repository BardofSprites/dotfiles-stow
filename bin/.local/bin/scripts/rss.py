import requests
from bs4 import BeautifulSoup

# Function to find RSS feeds on a website
def find_rss_feeds(url):
    try:
        # Send an HTTP GET request to the website
        response = requests.get(url)
        
        # Check if the request was successful
        if response.status_code == 200:
            # Parse the HTML content of the page using BeautifulSoup
            soup = BeautifulSoup(response.text, 'html.parser')

            # Search for RSS feed links in the HTML using a common pattern
            rss_links = []
            for link in soup.find_all('a', href=True):
                href = link['href']
                if 'rss' in href or 'feed' in href or 'xml' in href:
                    rss_links.append(href)

            # If RSS feed links are found, return them
            if rss_links:
                return rss_links
            else:
                return "No RSS feeds found on this website."

        else:
            return f"Failed to retrieve the website. Status code: {response.status_code}"

    except requests.exceptions.RequestException as e:
        return f"Request failed: {e}"

if __name__ == "__main__":
    website_url = input("Enter the website URL: ")
    rss_feeds = find_rss_feeds(website_url)

    if isinstance(rss_feeds, list):
        print("RSS feeds found on the website:")
        for rss_feed in rss_feeds:
            print(rss_feed)
    else:
        print(rss_feeds)
