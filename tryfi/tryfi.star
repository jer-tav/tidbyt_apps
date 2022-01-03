# TryFi Tidbyt Application
# Jeremy Tavener
# MIT License
load("render.star", "render")
load("http.star", "http")

API_BASE_URL = "https://api.tryfi.com"
API_LOGIN_URL = API_BASE_URL + "/auth/login"
API_GRAPHQL = API_BASE_URL + "/graphql"

def main(config):
    username = config.get("username")
    password = config.get("password")
    pet_name = config.get("pet_name")

    if username == None or password == None or pet_name == None:
        fail("Required arguments were not provided.")
    
    resp = http.post(API_LOGIN_URL, json_body={"email":username, "password":password})

    if resp.status_code != 200:
        fail("Failed to auth with the TryFi API with status {}".format(resp.status_code))

    session_id = resp.json()["sessionId"]
    cookie = resp.headers["Set-Cookie"]

    # Get a list of all the pets for the current user and find the one that matches the name from the config
    pets_query_url = "{ currentUser { pets { name id } } }"

    resp = http.post(API_GRAPHQL,headers={"sessionId":session_id, "Cookie":cookie}, json_body={"query":pets_query_url})
    if resp.status_code != 200:
        fail("Failed to query the TryFi API for the pet list with status {}".format(resp.status_code))

    pets = resp.json()["data"]["currentUser"]["pets"]
    pet_id = None

    for pet in pets:
        if pet["name"] == pet_name:
            pet_id = pet["id"]
            break

    if pet_id == None:
        fail("Couldn't find pet with name {}".format(pet_name))

    pet_query_url = "{pet (id: \"" + pet_id + "\") { name dailyStat: currentActivitySummary (period: DAILY) { totalSteps stepGoal } } }"

    resp = http.post(API_GRAPHQL,headers={"sessionId":session_id, "Cookie":cookie}, json_body={"query":pet_query_url})
    if resp.status_code != 200:
        fail("Failed to query the TryFi API with status {}".format(resp.status_code))

    daily_steps = resp.json()["data"]["pet"]["dailyStat"]["totalSteps"]
    step_goal = resp.json()["data"]["pet"]["dailyStat"]["stepGoal"]

    return render.Root(
        child = render.Box(
            render.Column(
                expanded=True,
                cross_align="center",
                main_align="space_evenly",
                children = [
                    render.Text(content=pet_name, font="5x8"),
                    render.Text(str(int(daily_steps)) + "/" + str(int(step_goal)))
                ],
            )
        )
    )
