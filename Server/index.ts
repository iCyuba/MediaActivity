Bun.serve({
  async fetch(request, server) {
    const id = parseInt(request.url.split("/").pop() ?? ``);

    if (isNaN(id)) return new Response(null, { status: 404 });

    const lookup = await fetch(`https://itunes.apple.com/lookup?id=${id}`).then(
      (res) => res.json()
    );

    const url = lookup.results?.[0]?.artworkUrl100?.replace(
      "100x100",
      "600x600"
    );
    if (!url) return new Response(null, { status: 404 });

    const response = await fetch(url);

    if (response.status === 200) {
      return response;
    }

    return new Response(null, { status: 404 });
  },
  port: 3000,
});
