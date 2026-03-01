# installing uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# creating venv and installing zensical
uv init
uv add --dev zensical

source .venv/bin/activate
zensical serve
