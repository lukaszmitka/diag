# diag

Tool for getting system diagnostic info.

# How to use

There are two use cases for the tool, first for user and second for support team.

## For users

If you want to report a problem, this tool will help you to gather most frequently used system configurations in one file, this should speed up the problem analysis process.

Run the diagnostic script to generate `data.tar.gz` file:

```
curl https://raw.githubusercontent.com/lukaszmitka/diag/master/get_diagnostics.sh | bash
```
 
When reporting problem to the Husarion team, attach generated file along with problem description.

## For support team

### Installation

Clone the repo:

```
git clone https://github.com/lukaszmitka/diag.git
```

Install dependencies:

```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
cd diag
npm install
```

### Problem analysis

Extract the file provied by user and start nodejs app:

```
tar -zxvf data.tar.gz
npm start
```

Then open `localhost:3000` in your browser and analyze the problem.
