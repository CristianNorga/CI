export default defineTask({
	meta: {
		name: 'ci:init',
		description: 'Initialize CI environment',
	},
	async run({ payload, context }) {
		const { GITHUB_TOKEN, REPO_OWNER, REPO_NAME } = process.env;

		if (!GITHUB_TOKEN || !REPO_OWNER || !REPO_NAME) {
			throw new Error('Missing required environment variables.');
		}

		const repoUrl = `https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO_OWNER}/${REPO_NAME}.git`;

		console.log(`🔧 Cloning repo: ${REPO_OWNER}/${REPO_NAME}`);

		const { execSync } = await import('node:child_process');
		try {
			execSync(`git clone ${repoUrl}`, { stdio: 'inherit' });
			process.chdir(REPO_NAME);
			console.log(`📂 Changed directory to ${REPO_NAME}`);
		} catch (error) {
			console.error('❌ Error cloning repository:', error);
			throw error;
		}

		return { result: 'Repository cloned and environment initialized.' };
	},
});
