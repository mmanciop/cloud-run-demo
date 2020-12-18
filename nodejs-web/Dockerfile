FROM node:14-buster

RUN apt-get update && apt-get install build-essential
COPY --from=instana/google-cloud-run-nodejs:latest /instana /instana
RUN /instana/setup.sh
ENV NODE_OPTIONS="--require /instana/node_modules/@instana/google-cloud-run"

# The additional packages needed to compile native add-ons can be removed after running
# the /instana/setup.sh script (results in smaller image).
RUN apt-get remove -y build-essential

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND package-lock.json (when available).
# Copying this first prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
# If you add a package-lock.json, speed your build by switching to 'npm ci'.
# RUN npm ci --only=production
RUN npm install --only=production

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD [ "node", "index.js" ]
