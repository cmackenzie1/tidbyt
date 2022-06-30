"""
Applet: Host ping
Summary: Response times for popular websites
Description: Displays the time to fetch popular websites
Author: Cole Mackenzie
"""

load("render.star", "render")
load("time.star", "time")
load("http.star", "http")

number_font = "tom-thumb"
font = "tom-thumb"


def main(config):
    hosts = [
        # tuples of (url, label, color)
        ("https://google.com/robots.txt", "Google", "#4285F4"),
        ("https://cloudflare.com/robots.txt", "Cloudflare", "#E06D10"),
        ("https://facebook.com/robots.txt", "Facebook", "#4267B2"),
    ]

    # burn a request to cache the http client
    resp = http.get("https://wikipedia.org", headers={"cache-control": "no-cache"})

    horizonal_rule = render.Box(
        height=1,
        color="#555",
    )

    rows = []

    i = 0
    for host in hosts:
        i += 1

        start = time.now()
        resp = http.get(host[0], headers={"cache-control": "no-cache"})
        end = time.now()

        delay = end - start

        host_name = render.Box(
            height=7,
            width=43,
            child=render.Padding(
                pad=(4, 0, 0, 0),
                child=render.Marquee(
                    width=43,
                    child=render.Text(
                        content=host[1],
                        color=host[2],
                        font=font,
                        offset=-1,
                    ),
                ),
            ),
        )

        host_time = render.Box(
            child=render.Padding(
                pad=(0, 1, 0, 1),
                child=render.Row(
                    children=[
                        render.Text(
                            content=str(delay.milliseconds),
                            font=number_font,
                            color="#ffffff",
                        ),
                        render.Text(
                            content="ms",
                            font=number_font,
                            color="#ffffff",
                        ),
                    ],
                ),
            ),
            width=23,
            height=7,
        )

        row = render.Row(
            main_align="start",
            children=[
                host_name,
                host_time,
            ],
        )
        rows.append(row)
        if i < len(hosts):
            rows.append(horizonal_rule)

    return render.Root(
        delay=500,
        child=render.Column(
            children=rows,
            main_align="space_around",
            expanded=True,
        ),
    )
