# Split Brain

Split Brain keeps track of standings in fantasy football double-header leagues. The way a double-header league works is this: for any given week, you get one point if you win your head-to-head matchup. You get an additional point (we’ll call it a bonus point from now on, though I wonder if there is a more official name for it) if you are in the top half of point totals for that week. It will do this by using the Yahoo Fantasy Sports API to retrieve information about leagues; within each league, we will keep track of matchups and calculate points on the fly.

## Architecture

* Python Flask app
* Database: PostgreSQL
* Cache/Queue: Redis
* Front-end technology: React + Bootstrap
* Hosting environment: Heroku
* Point calculation triggers: Celery with celery beat

## User/Data Flow

1. User loads page
2. Page prompts user to initiate OAuth flow
3. Going through OAuth flow, we get an access token
	* This access token should be stored in the browser. We will also store a user ID in the browser to tie the two together. Open question should we store this in the DB? My gut here is no: no need to do that. But we need to validate that we can query S2S to update rankings.
4. We query the API for their league(s)
5. If the user is in multiple leagues, prompt them for their league
6. If the league is already being managed by Split Brain, we can just go directly into it
7. We query Yahoo API for the standings and results of this league
8. We build database tables for this league
9. Twice weekly we rebuild rankings and standings: Tuesday (to get the just-finished week’s information) and Thursday (in order to see any stat corrections that took place)

## Data structures/relationships

* League: a fantasy league
* League Years?
* Team: a team within a league
	* league_id FK to leagues
	* manager_id FK to managers
* Manager: An operator of any number of teams
	* The managers table will also manage auth relationships
* Results
	* team_id FK to teams
	* points
	* year
	* week
* Top Ranked teams
	* View on results
	* rank on points desc
	* points using rank in top half

## UI

The UI  can be fairly simple here. In reality, we only need a few elements:

1. A league view with overall point totals (W/L/T/Bonus)
2. A week view with a simple table for matchups, along with an ordered table of point totals with the bonus winners highlighted


## Yahoo API Notes

Having sub-resources allows you to chain together Resources and Collections to provide more data, and the URI you request directly specifies how the chaining works. For instance, if you wanted to take a particular logged in user, see which games he had played, and then get the league information within those games, you might construct a request like:

(To be finished)
