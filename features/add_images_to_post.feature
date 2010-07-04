Feature: Add images to post
  As a blog maintainer
  In order to prevent broken images
  I want foreign images to be imported automatically

  Scenario: Import images
    Given I am logged in as an admin
    When I create a post with an image at "http://www.google.com/goldberg10-hp-sprite.png"
    Then there should be images in the database
      And the post's images should be reassigned

  Scenario: Pull referenced image
    Given I am logged in as an admin
    When I create a post with an image at "http://www.google.com/goldberg10-hp-sprite.png"
    Then there should be an image called "goldberg10-hp-sprite"
    