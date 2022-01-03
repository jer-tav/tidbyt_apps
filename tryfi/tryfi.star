# Attempt to connect to the Fi API and display a pet's step count.
load("render.star", "render")
load("http.star", "http")

VAR_USERNAME = "USERNAME"
VAR_PASSWORD = "PASSWORD"
VAR_PET_ID = "PET_ID"

API_BASE_URL = "https://api.tryfi.com"
API_LOGIN_URL = API_BASE_URL + "/auth/login"
API_GRAPHQL = API_BASE_URL + "/graphql"

QUERY_PET_DEVICE_DETAILS = "{pet (id: \"" + VAR_PET_ID + "\") { name dailyStat: currentActivitySummary (period: DAILY) { totalSteps stepGoal } } }"

def main():
    resp = http.post(API_LOGIN_URL, json_body={"email":VAR_USERNAME, "password":VAR_PASSWORD})

    if resp.status_code != 200:
        fail("Failed to auth with the TryFi API with status %d", resp.status_code)

    session_id = resp.json()["sessionId"]
    cookie = resp.headers["Set-Cookie"]

    resp = http.post(API_GRAPHQL,headers={"sessionId":session_id, "Cookie":cookie}, json_body={"query":QUERY_PET_DEVICE_DETAILS})

    if resp.status_code != 200:
        fail("Failed to query the TryFi API with status %d", resp.status_code)

    pet_name = resp.json()["data"]["pet"]["name"]
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
