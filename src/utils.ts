export const sanitiseString = (str: string) => {
  const escapeChars = {
    '&': '\\&',
    _: '\\_',
  };

  const regex = new RegExp(Object.keys(escapeChars).join('|'), 'g');

  return str.replace(regex, (matched) => escapeChars[matched as keyof typeof escapeChars]).trim();
};
